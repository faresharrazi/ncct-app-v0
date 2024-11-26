import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["account", "category"];

    connect() {
        console.log("Transaction controller connected.");
    }

    async updateCategories() {
        const accountId = this.accountTarget.value;

        if (accountId) {
            const response = await fetch(`/accounts/${accountId}/categories`);
            const categories = await response.json();

            // Clear the category dropdown
            this.categoryTarget.innerHTML = '<option value="">Select a category</option>';

            // Populate the dropdown with categories
            categories.forEach(category => {
                const option = document.createElement("option");
                option.value = category.id;
                option.textContent = category.name;
                this.categoryTarget.appendChild(option);
            });
        } else {
            // Clear the category dropdown if no account is selected
            this.categoryTarget.innerHTML = '<option value="">Select an account first</option>';
        }
    }
}
