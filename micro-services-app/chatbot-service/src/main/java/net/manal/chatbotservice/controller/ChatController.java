package net.manal.chatbotservice.controller;

import net.manal.chatbotservice.service.RAGService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChatController {

    private final RAGService ragService;

    public ChatController(RAGService ragService) {
        this.ragService = ragService;
    }

    @GetMapping("/chat")
    public String chat(@RequestParam String question) {
        return ragService.generateAnswer(question);
    }
}
