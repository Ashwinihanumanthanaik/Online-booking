// ============================================================
//  CART.JS - Cart management using LocalStorage
// ============================================================

const Cart = {
    STORAGE_KEY: 'ecommerce_cart',

    // Get all cart items
    getItems() {
        try {
            return JSON.parse(localStorage.getItem(this.STORAGE_KEY)) || [];
        } catch {
            return [];
        }
    },

    // Save cart items
    save(items) {
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify(items));
        this.updateBadge();
        document.dispatchEvent(new CustomEvent('cartUpdated', { detail: { items } }));
    },

    // Add item to cart
    addItem(product) {
        const items = this.getItems();
        const existing = items.find(i => i.id === product.id);
        if (existing) {
            existing.quantity += (product.quantity || 1);
        } else {
            items.push({
                id: product.id,
                name: product.name,
                price: product.price,
                imageUrl: product.imageUrl || product.image_url || '',
                category: product.category || '',
                quantity: product.quantity || 1
            });
        }
        this.save(items);
        return items;
    },

    // Remove item from cart
    removeItem(productId) {
        const items = this.getItems().filter(i => i.id !== productId);
        this.save(items);
    },

    // Update quantity
    updateQuantity(productId, quantity) {
        const items = this.getItems();
        const item = items.find(i => i.id === productId);
        if (item) {
            if (quantity <= 0) {
                this.removeItem(productId);
                return;
            }
            item.quantity = quantity;
            this.save(items);
        }
    },

    // Clear cart
    clear() {
        localStorage.removeItem(this.STORAGE_KEY);
        this.updateBadge();
        document.dispatchEvent(new CustomEvent('cartUpdated', { detail: { items: [] } }));
    },

    // Get total item count
    getCount() {
        return this.getItems().reduce((sum, i) => sum + i.quantity, 0);
    },

    // Get subtotal
    getSubtotal() {
        return this.getItems().reduce((sum, i) => sum + (i.price * i.quantity), 0);
    },

    // Update cart badge in navbar
    updateBadge() {
        const badge = document.getElementById('cart-badge');
        if (badge) {
            const count = this.getCount();
            badge.textContent = count;
            badge.style.display = count > 0 ? 'inline' : 'none';
        }
    }
};

// ============================================================
//  TOAST NOTIFICATIONS
// ============================================================
const Toast = {
    container: null,

    init() {
        if (!document.getElementById('toast-container')) {
            this.container = document.createElement('div');
            this.container.id = 'toast-container';
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        } else {
            this.container = document.getElementById('toast-container');
        }
    },

    show(message, type = 'success', duration = 3000) {
        if (!this.container) this.init();
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        const icon = type === 'success' ? '✓' : '✕';
        toast.innerHTML = `<span>${icon}</span> ${message}`;
        this.container.appendChild(toast);
        setTimeout(() => {
            toast.style.animation = 'slideIn 0.3s ease reverse';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }
};

// ============================================================
//  INIT ON PAGE LOAD
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    Toast.init();
    Cart.updateBadge();
});
