import { Customer } from "./customer.model";
import { Product } from "./product.model";

export interface ProductItem {
    id: number;
    productID: string;
    price: number;
    quantity: number;
    product?: Product; // Enriched data
}

export interface Bill {
    id: number;
    billingDate: Date;
    customerID: number;
    productItems: ProductItem[];
    customer?: Customer; // Enriched data
    total?: number; // Calculated
}
