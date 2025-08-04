-- Insert 1000+ book records with repetitive author & category values
do $$
declare
    i int := 1;
    a text[] := array['Jane Austen','George Orwell','J.K. Rowling','Isaac Asimov','Stephen King','Agatha Christie','J.R.R. Tolkien','Mark Twain','Leo Tolstoy','C.S. Lewis'];
    c text[] := array['Fiction','Science Fiction','Mystery','Fantasy','Drama','Historical','Adventure','Horror','Children','Nonfiction'];
begin
    while i <= 1000 loop
        insert into books (title, author, category, published_year)
        values (
            'Book #'||i,
            a[(i%10)+1],
            c[(i%10)+1],
            1980 + (i%40)
        );
        i := i + 1;
    end loop;
end$$;
