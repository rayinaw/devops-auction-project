'use server'

import { Auction, PagedResult } from "@/types";
import { getTokenWorkaround } from "./authActions";

export async function getData(query: string): Promise<PagedResult<Auction>>{
    const res = await fetch(`${process.env.API_URL}/search${query}`);
    console.log(`${process.env.API_URL}/search${query}`);

    console.log(res.statusText);

    if (!res.ok) throw new Error('Failed to fetch data');

    return res.json();
}

export async function UpdateAuctionTest() {
    const data = {
        milage: Math.floor(Math.random() * 10000) + 1
    }

    const token = await getTokenWorkaround();

    const res = await fetch(`${process.env.API_URL}/auctions/afbee524-5972-4075-8800-7d1f9d7b0a0c`, {
        method: 'PUT',
        headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer ' + token?.access_token
        },
        body: JSON.stringify(data)
    })

    if (!res.ok) return {status: res.status, message: res.statusText}

    return res.statusText
}