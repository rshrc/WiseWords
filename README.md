# Hotwire for Flutter Devs: Building a Dynamic Quote Generator with TailwindCSS

Hey there, Flutter developers! 🚀 I know the idea of moving to a web framework can sound intimidating—especially without Flutter's widget magic—but Hotwire makes it easy, powerful, and fun. Today, we're going to build a **Quote Generator** using **Hotwire** and **TailwindCSS**. You may be thinking: *"HTML over the wire? Really?"* But trust me, this is going to feel just like `setState()` in Flutter but for the web, with the added bonus of having far less JavaScript to manage!

Let’s dive right in and see how you can use **Turbo Frames** to make a smooth, dynamic user experience, with only minimal changes to your server-side code.

---

## What is Hotwire?

**Hotwire** (HTML Over The Wire) is a toolkit to make dynamic web apps with minimal JavaScript. Hotwire is made up of a few components, but today we'll focus on **Turbo**. Turbo is all about making your web app snappy, without needing to write reams of JavaScript.

It’s sort of like `setState()` in Flutter, but for the server-side: you make changes to your server data, and the page updates itself. We'll use **Turbo Frames** in this app, which will update parts of our page in a flash without a full page reload.

---

## The Plan: A Simple Quote Generator

We'll build a small application with a **header**, **footer**, and a **quote text** that updates every time you click the **"Generate Quote"** button. The core idea is to:

- Use **Turbo Frames** to update only the part of the page that changes (the quote text).
- Use **TailwindCSS** to style it, keeping it simple and consistent.

Our goal: have the quote update dynamically, without a full page reload, keeping the header, footer, and button intact.

---

## Setting Up Rails with Hotwire and TailwindCSS

First, we’ll create a new Rails app with Tailwind already set up:

```bash
rails new wise_words --css=tailwind
cd wise_words
```

The `--css=tailwind` flag will install TailwindCSS and configure it for us, and `cd wise_words` moves us into our new app directory.


### Step 1: Generating a Quotes Controller

We need to handle showing and generating quotes, so let’s create a controller for that:

```bash
rails generate controller Quotes
```

This creates:

- `app/controllers/quotes_controller.rb` – where we handle the logic for generating quotes.
- View directory `app/views/quotes/` where we'll add our UI.


### Step 2: Defining Routes

Let’s add a couple of routes to handle our home page and quote generation:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "quotes#index"
  post "generate_quote", to: "quotes#generate", as: :generate_quote
end
```

- `root "quotes#index"` sets the homepage to show the initial quote.
- `post "generate_quote"` points the button action to our controller's `generate` method.


### Step 3: Building the Quotes Controller

Open `quotes_controller.rb` and add the quote-generating logic:

```ruby
# app/controllers/quotes_controller.rb
class QuotesController < ApplicationController
  def index
    @quote = "Click the button to generate a quote."
  end

  def generate
    quotes = [
      "Believe you can and you're halfway there.",
      "The only way to do great work is to love what you do.",
      "Life is what happens when you're busy making other plans.",
      "Don't watch the clock; do what it does. Keep going.",
      "The best way to predict the future is to invent it."
    ]
    @quote = quotes.sample
    render partial: "quote", locals: { quote: @quote }
  end
end
```

**Explanation:**
- `index` initializes the `@quote` variable with a default message.
- `generate` selects a random quote from our list and renders the partial without reloading the entire page.


### Step 4: Creating the Views

#### **Layout File (Header, Footer, Main Content)**

Create or modify the layout file to include the header, footer, and main container:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html class="h-full">
  <head>
    <title>Wise Words</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    
    <%= stylesheet_link_tag "tailwind", "data-turbo-track": "reload" %>
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body class="min-h-screen flex flex-col">
    <header class="flex-none p-4 bg-blue-500 text-white text-center font-bold">
      Wise Words Generator
    </header>
    <main class="flex-1 flex items-center justify-center">
      <%= yield %>
    </main>
    <footer class="flex-none p-4 bg-gray-800 text-white text-center">
      © 2024 Wise Words Inc.
    </footer>
  </body>
</html>
```

**Explanation:**
- The `<%= yield %>` is where our view content will be rendered.
- Header and footer are styled using **TailwindCSS** classes.

#### **Index View**

Create the main page where users can see the quote and click the button to generate a new one:

```erb
<!-- app/views/quotes/index.html.erb -->
<div class="flex flex-col items-center justify-center h-full space-y-6">
  <%= render partial: "quote", locals: { quote: @quote } %>
  
  <%= form_with url: generate_quote_path, method: :post, data: { turbo_frame: 'quote_frame' } do %>
    <%= submit_tag "Generate Quote", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" %>
  <% end %>
</div>
```

- This view renders the quote, and the form with a submit button.
- **Note**: We use `form_with` and specify `data: { turbo_frame: 'quote_frame' }` to ensure that only the targeted Turbo Frame is updated.


#### **Quote Partial**

Create a partial to display the quote text:

```erb
<!-- app/views/quotes/_quote.html.erb -->
<turbo-frame id="quote_frame">
  <div id="quote" class="text-xl font-semibold text-gray-700">
    <%= quote %>
  </div>
</turbo-frame>
```

**Explanation:**
- We wrap the quote content in a `<turbo-frame>` with `id="quote_frame"`. This allows us to update only this part of the page whenever a new quote is generated.
- Using **Turbo Frames** here means only the frame content is updated, keeping the rest of the page intact.


### Step 5: TailwindCSS Setup

You mentioned that **TailwindCSS** wasn't working initially. Here's a quick fix if you run into issues:

- Precompile the assets to make sure Tailwind is properly included:

  ```bash
  rake assets:precompile
  ```

This should ensure that TailwindCSS styles are available and correctly applied to your app.


## How It Works Together

- **Turbo Frames** handle partial page updates, so clicking "Generate Quote" fetches new HTML for the frame without a full page reload.
- The **form_with** sends the request to generate a new quote, and the response replaces the content inside the `quote_frame`.
- **TailwindCSS** gives us a clean, styled UI without having to write custom CSS from scratch.

**End Result**: You click the button, and only the quote updates—the header, footer, and the rest of the page remain unchanged. Smooth, fast, and super satisfying.


## Final Thoughts

Hotwire and **Turbo Frames** bring a powerful, easy way to make your web apps dynamic—just like `setState()` in Flutter but for server-side HTML. This approach avoids the complexity of heavy JavaScript frameworks while still giving you a highly interactive user experience.

Give Hotwire a shot, and you might just find yourself enjoying Rails development even more than before. Pair it up with **TailwindCSS**, and you get an aesthetically pleasing, dynamic app without touching much JavaScript or CSS!

