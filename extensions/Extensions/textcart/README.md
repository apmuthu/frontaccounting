# Module Textcart
## Introduction
This module provides a quick import/export facility between **orders** (or any other carts) and text via the UI.
This allows, for example :

* copy/paste from a Sales Order to a Purchase Order or another Sales Order
* quick modification of an order
* modifying an Order with Excel
* converting email to order
* bulk import of big order
* variant, made easy via the Line Templating System (LTS)
* and much more

Note that this module doesn't create or save orders in the database. It's just an alternative to the current UI for building an order, which then needs to be saved.
## Why exporting to text?
FA is a web application, therefore you expect to be able to enter an order using the mouse via the user friendly UI, which FA provides.
However, as nice as a mouse interface can be, entering or manipulating a text can be quicker and allows you to use whatever tool you want to modify it.
You might want to copy a sales order to a purchase order whilst modifying the quantity to match the supplier minimum quantities or multiply all the prices by a certain factor. It's not easy with a mouse, but it's easy with Excel or any text editor.

## How does it work?
Just go to any **cart** page (Sale Order, Purchase Order or Item Adjustment/Transfer) and select the *Text* cart next to the *Order* one.
You should then get your order translated in text (if it's not empty).
You can then copy/paste it into excel or anything else, modify it and re inject it in the same cart or another one. You'll then be able to see your **cart** in the normal UI, check it and save the order if needed.
### Syntax overview
The format of a textcart is a bit complicated to explain but it's easy to write and grasp by example.
If you edit an existing order (or add a few items in an empty one) and select the **Text** cart tab, you should have something like this :

      -- some lines starting with '--''
      -- there are comments (so ignored by FA)
      -- they are a quick reminder of the syntax

then the details of the cart like :

      ITEM1 + 10 $ 4.00 5.0 % | "description of item 1"
      ITEM2 +  8 $ 5.00 0.0 % | "description of item 2"
etc ...

This means you have two items in your cart, the first item being : 

ITEM1, quantity 10, price 4.00 and a discount of 5%.

***Warning*** : the **$** sign here is not related to your currency, it's just a symbol meaning price.
The format might be a bit alarming, but this one is meant to be exportable to Excel and have all the information without any ambiguity. You don't need to write everything.

The minimum that you need to write is, the item *stock_code*.
Then if you want (in no particular order), the quantity, the price and the discount,
(quantities are preceded by '**+**', prices by '**$**' and discount followed by '**%**' ).
Finally an optional description preceded by a '**|**' enclosed or not with double-quotes.

* fields can be separated by spaces, tabs and/or commas. 
* order doesn't matter (for quantity, price and discount)
* field identifiers ('**+**', '**$**', '**%**') can be attached or separated to their value
* '**+**' is optional if the quantity is an integer (like *8*)
* '**$**' is optional if the price is a decimal number (like *5.00*)
* the default quantity is 1

So, the following lines are equivalent (considering that *4.00* is the default price and *"description of item 1"* is the real item description)

      ITEM2 +  8 $ 5.00 0.0 % | "description of item 2"
      ITEM2 +8 $5.00 0.0% | description of item 2 
      ITEM2 +8,  $5.00, 0.0%, | description of item 2 
      ITEM2 8 5.00 
      ITEM2 5.00 8
      ITEM2 8 $5 

However 

      ITEM2 8 5 

is wrong, as *5* will be seen as a quantity, and not a price.

(*Note for Excel users*) If you copy/paste into Excel you should have 8 columns. The separation between the '**$**' sign and the amount is deliberate. Without that, Excel (my version at least) would consider the column as a string, so it's easier that way.

Lines can also contain formulas and default values through a simple but powerful line templating system (see the *Templating System* section).

## Update Modes
Once, you are happy with your text (either entered directly in the text area, or copied from somewhere) you can either replace the whole order, update a part of it or just insert some items.

Let's say your original cart contains :

    ITEM-1 10
    ITEM-2 5

And your textcart is :

    ITEM-2 10

* **Replace** will replace all the items with the ones in the textcart. In this case the resulting cart will be :

    ITEM-2 10
* **Insert** will append the whole textcart to the original order resulting in :


    ITEM-1 10
    ITEM-2 5
    ITEM-2 10
 
We have 2 lines with ITEM-2.

* **Update** will update the lines of the original cart with the new value.

    ITEM-1 10
    ITEM-2 10
   
    ITEM-2 quantity has change to 10.

Modes an also be overridden for each individual line by starting with either :  

* '**+**' insert the current line
* '**=**' update the current line
* '**-**' delete the current line.
  
## Examples
### Suppress some lines from a cart
You want to suppress ITEM-2 from the following cart:

    ITEM-1 10
    ITEM-2 5

#### 1st method
Delete the line ITEM2 from the text, the textcart will look like this :

    ITEM-1 10

and press *Replace*.
#### 2nd method
Write a text cart to delete ITEM2 with the following :

    -ITEM2

And press *Insert*.

### Update
You want to change the quantity  of ITEM-2 from the following cart to 1:

   ITEM-1 10
   ITEM-2 5

### 1st method
Edit the cart just to change the quantity of ITEM-2 to 1.

   ITEM-1 10
   ITEM-2 1

And press *Replace*.
### 2nd method
Just write the line you want to change :

   ITEM-2 1

and press *Update*.

### Import/Export to Excel
If you need to do some complex modifications via Excel, just copy/paste the textcart to Excel, do your modifications, then copy/paste the desired cart from Excel to the text area and press *Replace*.
### Sales order to purchase order
If you want to create a purchase order from a sales order, do the following :

* just copy the textcart from the sales order
* create a new purchase order, select the text tab from the **Purchase Order** page
* paste the sales order textcart in the textcart area
* at this point, we need to change the sales price by the purchasing price. The quickest to do so is to insert the following line (*Template Line*) at the beginning of the textcart 

      :# $(@)

* press *Replace* and save your order.

If you need to do fancy calculations beforehand (like matching the quantity to the minimum quantity required by the supplier), export the cart to Excel (or anything else), make the desired changes to the quantities and prices then import it to the purchase order.

### Transfer all items from one location to another one
For **Transfer** and **Adjusement** items, if the cart is empty, the default textcart, rather than being empty, will be initially filled with all the items present in the specific location.

## Line Templating System
For people who need to write big orders from scratch, the line templating system (LTS) allows orders to be written in a really compact way, without having to repeat what doesn't change from line to line.
Lines sharing the same pattern can be captured to a *line template*.

### Syntax
A Line template is identical to a normal line, except it starts with a ':'. It can contain constants (default values) and/or placeholders ('**#**','**@**').

* '**#**' will be replaced by the value corresponding to the same field of the current line
* '**@**' will be replaced by the default value (from the database)

In the same way, '**#**' can be used on a normal line and will be replaced by the value of the template.

### Examples
Let's say that we have the following cart

      ITEM-1 10
      ITEM-2 10
      ...
      ITEM-5 10

We don't want to write the number 10 each time, so, let's define a template line this way :

      :# 10


'**:**' means the line is a template line.

'**#**' is a placeholder for the stock_code (ignore this for the moment)

*10* is the default quantity.

Each following line would look like the template with the '**#**' expanded (replaced) with the stock code.
So, the line :
 
      ITEM-1
will be replaced by :

      ITEM-1 10
And the line :

      ITEM-2
will be replaced by :

ITEM-2 10

Therefore, instead of the initial cart, we can write this :

      :# 10
      ITEM-1
      ITEM-2
      ...
      ITEM-5

They are equivalent, but the later one is shorter.

Placeholders can be used in any field and will be replaced by the value of the corresponding field.
In the same way, if the stock codes follow a certain pattern (colour variant) we can use a placeholder to construct the stock_code or the description.

Let's say we want the following order :


      T-Shirt/Blue 5
      T-Shirt/Red 5
      T-Shirt/Black 10

We can write instead :

      :T-Shirt/# 5
      Blue
      Red
      Black 10


`Blue`  will be expanded to `T-Shirt/Blue 5`

`Red` to `T-Shirt/Red 5`

***Note*** The quantity for black : *10* will override the template's one.

If we want to add the colour to the description, we just need to write the bit of the description which differs for each product.

      :T-Shirt/# | this a # t-shirt
      Blue | blue
      Red | red
      Black | black

Is equivalent to :

      T-Shirt/Blue | this a blue t-shirt
      T-Shirt/Red | this a red t-shirt
      T-Shirt/Black | this a black t-shirt


#### Placeholder in a normal line
You can also use a placeholder in a normal line, it will be replaced by the value in the template.

Example :

      :Blue | blue
      T-shirt/# | this a # shirt
      Skirt/#   | this a # skirt

Is equivalent to :

      T-shirt/Blue | this a blue shirt
      Skirt/Blue   | this a blue skirt

### Formula
Formulas between brackets will be evaluated as arithmetical expressions.

Example, to knock down by 10% the price of every item of an existing order.

Current cart :

      ITEM-1 10.0
      ITEM-2 20.0

Desired cart :

      ITEM-1 9.0
      ITEM-2 18.0

You can do :

      :# $( # * 0.90 )
      ITEM-1 10.0
      ITEM-2 20.0

### Raw line
A line starting with a '**!**' will not be expanded :

Example

      :# $( # * 0.90 )
      ITEM-1 10.0
      !ITEM-2 20.0

will give:

      ITEM-1 9.0
      ITEM-2 20.0

Note the quantity of *20* form ITEM-2.

### Forcing value
In the following cart :

      :# 10
      ITEM-1
      ITEM-2 4

The line values have priority over the template values. Therefore this cart is equivalent to

      ITEM-1 10
      ITEM-2 4

The *4* of the 2nd line overwrites the default value of the template.

If you want to force **Textcart** to use the template value, use a **constant formula** (as formulas have priority over constants).

The following cart :

      :# (10)
      ITEM-1 
      ITEM-2 4
 
will be equivalent to :

      ITEM-1 10
      ITEM-2 10
