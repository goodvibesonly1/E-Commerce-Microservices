package net.manal.chatbotservice.service;

import org.springframework.ai.chat.ChatClient;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class RAGService {

    private final ChatClient chatClient;
    private final net.manal.chatbotservice.feign.CustomerRestClient customerRestClient;
    private final net.manal.chatbotservice.feign.ProductRestClient productRestClient;
    private final net.manal.chatbotservice.feign.BillRestClient billRestClient;

    public RAGService(ChatClient chatClient, 
                      net.manal.chatbotservice.feign.CustomerRestClient customerRestClient,
                      net.manal.chatbotservice.feign.ProductRestClient productRestClient,
                      net.manal.chatbotservice.feign.BillRestClient billRestClient) {
        this.chatClient = chatClient;
        this.customerRestClient = customerRestClient;
        this.productRestClient = productRestClient;
        this.billRestClient = billRestClient;
    }

    public String generateAnswer(String query) {
        // Fetch Real-Time Data for Context
        String context = "";
        StringBuilder contextLog = new StringBuilder("Attempting to fetch dynamic context:\n");
        try {
            String customers = "No customers found";
            try {
                customers = customerRestClient.getAllCustomers();
                contextLog.append("- Customer Service: SUCCESS\n");
            } catch (Exception e) {
                contextLog.append("- Customer Service: FAILED (").append(e.getMessage()).append(")\n");
            }

            String products = "No products found";
            try {
                products = productRestClient.getAllProducts();
                contextLog.append("- Product Service: SUCCESS\n");
            } catch (Exception e) {
                contextLog.append("- Product Service: FAILED (").append(e.getMessage()).append(")\n");
            }

            String bills = "No bills found";
            try {
                bills = billRestClient.getAllBills();
                contextLog.append("- Bill Service: SUCCESS\n");
            } catch (Exception e) {
                contextLog.append("- Bill Service: FAILED (").append(e.getMessage()).append(")\n");
            }

            System.out.println(contextLog.toString());

            context = String.format("""
                    System Data Context:
                    Customers: %s
                    Products: %s
                    Bills: %s
                    """, customers, products, bills);
            
            // If all failed, use sample context for demo purposes
            if (context.contains("No customers found") && context.contains("No products found") && context.contains("No bills found")) {
                throw new Exception("All services unreachable");
            }
        } catch (Exception e) {
            System.err.println("Error fetching dynamic context: " + e.getMessage());
            // Fallback to sample context if services are down
            context = """
                    Sample E-Commerce Data:
                    Customers: [Mohamed (med@gmail.com), Imane (imane@gmail.com), Yassine (yassine@gmail.com)]
                    Products: [Laptop ($999), Phone ($599), Tablet ($399), Headphones ($149)]
                    Bills: [Bill#1: Mohamed bought Laptop, Bill#2: Imane bought Phone and Tablet]
                    """;
        }

        // Construct Prompt
        String template = """
                You are an intelligent assistant for an E-Commerce system called EMSI Shop.
                Answer the user's question based ONLY on the following context:
                {context}
                
                Question: {query}
                
                If you cannot find the answer in the context, say "I don't have that information in my database."
                Be helpful, friendly, and concise.
                """;
        
        PromptTemplate promptTemplate = new PromptTemplate(template);
        Prompt prompt = promptTemplate.create(Map.of("context", context, "query", query));

        // Generate Response using OpenAI
        try {
            return chatClient.call(prompt).getResult().getOutput().getContent();
        } catch (Exception e) {
            return "Error generating response: " + e.getMessage();
        }
    }
}
