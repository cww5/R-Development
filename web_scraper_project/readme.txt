README.txt                
Connor Watson, Xueyang Fan, Shreyas Patil
CS 636 - 101 | Midterm Project | Genome Biology Journal Web Scraper

scraper.R
Functionality described:
1. Create directory for the html files named "articles".
2. Create a data.frame to contain all the 10 fields as stated in the project description.
3. Define 2 functions:
	a. write_article_html takes a doi string and html content and writes the article 
	   file named after its doi to the articles folder.
	b. replace_empties will substitute any NA values after parsing web content.
4. Below is the base URL for all 126 pages of articles in the journal:
https://genomebiology.biomedcentral.com/articles?searchType=journalSearch&sort=PubDate&page=%d
5. For each page read the html content and retrieve the links for all the articles.
6. For each article on the page, open an HTML session to allow rvest to parse for the desired information.
7. We used an external webapp called SelectorGadget to inspect the elements of the article and retrieve the CSS class names. 
By using html_nodes() function, we can retrieve desired content by referencing the class names and pipe into html_text().
8. By using try_catch, if the page doesn't exists, we skip parsing the html content.
9. Information parsing.
	1. The DOI is retrieved by searching for ".u-text-inherit". We use the DOI to make the HTML files in the articles folder.
	2. Title is retrieved by searching for ".ArticleTitle".
	3. Authors are retrieved by searching for ".AuthorName". Because there are multiple authors, we paste and collapse into one string by ";".
	4. Corresponding Authors can be fetched by using the xpath attribute preceding-sibling "//*[@class='EmailAuthor']/preceding-sibling::span" 
	   by finding which author has an email address to contact to.
	5. Author affiliations were tricky to receive. We retrieved "meta" (ID) nodes and extracted "name" and "content" attributes. 
	   This was piped into citation_author_institution filtered by the previous information and then grouped in a data.frame to retrieve 
	   a group of all the affiliations for all authors. This column of information was pasted into one string.
	6. Emails were retrieved by finding ".EmailAuthor" nodes and getting attributes "href". In case there are multiple, these are pasted into a string separated by ";".
	7. Published date is retrieved by searching for ".u-reset-list" and extracted by Regular expression.
	8. Abstract is retrieved by searching "#Abs1".
	9. Keywords is retrieved by searching ".c-keywords". They are also collapse for in case.
	10. Full text is retrieved by searching "article".
10. For each searching result page of the journal website (126 in total), every articles are parsed by all 10 fields. 
(There are 50 in most of pages except the last page which has 11.) All the information is combined into one data frame.
11. All the combined information is written in to ".txt" file and named as "genomebiology.txt" (the journal name). 
All the data that are not available are replaced with “NA”.


scraper_reader.R
Functionality described:

1. It reads the genomebiology.txt file as required.
2. It gives all the data to “content” data.frame and convert the column names to the required format, allowing for special characters like pparenthesis or quotations.
3. Finally, it replaces all the empty items to “NA”.