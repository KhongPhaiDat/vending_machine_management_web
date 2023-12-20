# streamlit_app.py
import time
import streamlit as st
import modules.menu_component as menu_component
import modules.product_release_component as product_release_component


def main():
    st.title("Vending Machine Management App")
    # Menu
    menu = ["Update item amount/price", "Add item", "Remove item"]
    choice = st.sidebar.selectbox("Navigate", menu)

    if choice == "Update item amount/price":
        update_amount_price()
    elif choice == "Add item":
        add_item()
    elif choice == "Remove item":
        remove_item()


def remove_item():
    # Get machine ID from query parameter in the URL
    machine_id = st.experimental_get_query_params().get("id", ["1"])[0]

    # Get item list from database
    menu_comp = menu_component.MenuComponent()
    product_release_comp = product_release_component.ProductReleaseComponent()
    item_lists = menu_comp.queryMenuByMachineIDFromDatabase(machine_id)

    # Display the selected machine item list
    st.header(f"Current Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Allow user to edit the machine item list
    st.header("Remove Item from Inventory:")

    # User input for adding new item
    removing_item = st.selectbox(
        "Select item to remove:", list(item_lists.keys()))

    # Remove item from dictionary
    item_lists.pop(removing_item)

    # Display machine item list after change
    st.header(f"Updated Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Confirm button to update the database
    if st.button("Confirm Update"):
        # Perform the database update (simulated by printing here)
        response = product_release_comp.updateProductListToDatabase(
            machine_id, item_lists)
        if response == "":
            response = "Xóa item thành công"
        output_container = st.empty()
        output_container.write(response)
        time.sleep(4)
        output_container.empty()


def add_item():
    # Get machine ID from query parameter in the URL
    machine_id = st.experimental_get_query_params().get("id", ["1"])[0]

    # Get item list from database
    menu_comp = menu_component.MenuComponent()
    product_release_comp = product_release_component.ProductReleaseComponent()
    item_lists = menu_comp.queryMenuByMachineIDFromDatabase(machine_id)

    # Display the selected machine item list
    st.header(f"Current Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Allow user to edit the machine item list
    st.header("Add New Item to Inventory:")

    # User input for adding new item
    new_item = st.text_input(
        "Enter new item to add:")
    new_quantity = st.number_input(
        "Enter quantity:", min_value=0, step=1)
    new_price = st.number_input(
        "Enter price:", min_value=0, step=1)

    # Update the new item to dictionary
    item_lists[new_item] = {"amount": new_quantity, "price": new_price}

    # Display machine item list after change
    st.header(f"Updated Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Confirm button to update the database
    if st.button("Confirm Update"):
        # Perform the database update (simulated by printing here)
        response = product_release_comp.updateProductListToDatabase(
            machine_id, item_lists)
        if response == "":
            response = "Thêm item thành công"
        output_container = st.empty()
        output_container.write(response)
        time.sleep(4)
        output_container.empty()


def update_amount_price():
    # Get machine ID from query parameter in the URL
    machine_id = st.experimental_get_query_params().get("id", ["1"])[0]

    # Get item list from database
    menu_comp = menu_component.MenuComponent()
    product_release_comp = product_release_component.ProductReleaseComponent()
    item_lists = menu_comp.queryMenuByMachineIDFromDatabase(machine_id)

    # Display the selected machine item list
    st.header(f"Current Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Allow user to edit the machine item list
    st.header("Edit Machine Inventory:")

    item_to_edit = st.selectbox(
        "Select item to edit:", list(item_lists.keys()))

    # Get the current values
    current_quantity = item_lists[item_to_edit]['amount']
    current_price = item_lists[item_to_edit]['price']

    # User input for editing
    new_quantity = st.number_input(
        "Enter new quantity:", min_value=0, value=int(current_quantity), step=1)
    new_price = st.number_input(
        "Enter new price:", min_value=0, value=int(current_price), step=1)

    # Notify user if there is change in quantity or price
    handle_quantity_change(new_quantity, current_quantity)
    handle_price_change(new_price, current_price)

    # Update the store_data dictionary
    item_lists[item_to_edit]['amount'] = new_quantity
    item_lists[item_to_edit]['price'] = new_price

    # Display machine item list after change
    st.header(f"Updated Inventory for machine id {machine_id}:")
    st.table(item_lists)

    # Confirm button to update the database
    if st.button("Confirm Update"):
        # Perform the database update (simulated by printing here)
        response = product_release_comp.updateProductListToDatabase(
            machine_id, item_lists)
        if response == "":
            response = "Update thành công"
        output_container = st.empty()
        output_container.write(response)
        time.sleep(4)
        output_container.empty()


def handle_quantity_change(quantity_input, initial_quantity):
    if quantity_input != initial_quantity:
        st.write(
            f"Quantity has changed from **{initial_quantity}** to **{quantity_input}**")


def handle_price_change(price_input, initial_price):
    if price_input != initial_price:
        st.write(
            f"Price has changed from **{initial_price}** to **{price_input}**")


if __name__ == "__main__":
    main()
