export interface Category {
    id: string;
    name: string;
    name_th: string;
    icon: string;
    sort_order: number;
}

export interface BreadOption {
    id: string;
    name: string;
    name_th: string;
    price_add: number;
}

export interface ToppingOption {
    id: string;
    name: string;
    name_th: string;
    price_add: number;
}

export interface SauceOption {
    id: string;
    name: string;
    name_th: string;
}

export interface CustomizationConfig {
    breads: BreadOption[];
    toasts: { id: string; name: string; name_th: string }[];
    toppings: ToppingOption[];
    sauces: SauceOption[];
}

export interface MenuItem {
    id: string;
    category_id: string;
    name: string;
    name_th: string;
    description: string;
    description_th: string;
    price: number;
    original_price?: number;
    image_url: string;
    badge?: 'Best Seller' | 'Chef Pick' | 'New' | 'Healthy' | 'Spicy';
    is_available: boolean;
    calories?: number;
    customization_options?: CustomizationConfig;
    created_at?: string;
}

export interface CartItemOption {
    bread?: BreadOption;
    toast?: string;
    toppings?: ToppingOption[];
    sauces?: string[];
    notes?: string;
}

export interface CartItem {
    cart_id: string; // unique cart item id
    menu_item: MenuItem;
    quantity: number;
    options: CartItemOption;
    unit_price: number; // base price + options
    total_price: number;
}

export type OrderType = 'dine_in' | 'takeaway' | 'delivery';
export type OrderStatus = 'pending' | 'preparing' | 'ready' | 'completed' | 'cancelled';
export type PaymentMethod = 'promptpay' | 'cash' | 'credit_card';
export type PaymentStatus = 'pending' | 'paid';

export interface Order {
    id: string;
    order_number: string;
    order_type: OrderType;
    table_number?: string;
    customer_name?: string;
    customer_phone?: string;
    delivery_address?: string;
    status: OrderStatus;
    subtotal: number;
    discount: number;
    vat: number;
    total_amount: number;
    payment_method: PaymentMethod;
    payment_status: PaymentStatus;
    cash_tendered?: number;
    cash_change?: number;
    items: CartItem[];
    notes?: string;
    created_at: string;
    channel: 'online' | 'pos';
}

export interface StoreSettings {
    store_name: string;
    store_name_th: string;
    tagline: string;
    phone: string;
    address: string;
    promptpay_id: string; // Phone or Tax ID for PromptPay QR
    tax_rate: number; // e.g. 7 for 7%
    currency: string;
    supabase_url?: string;
    supabase_key?: string;
}
