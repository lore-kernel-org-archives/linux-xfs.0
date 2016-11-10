Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.postbox.xyz ([81.169.216.193]:52529 "EHLO
        mail2.postbox.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933205AbcKJOVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 09:21:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail2.postbox.xyz (Postfix) with ESMTP id BED38721823
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2016 15:15:48 +0100 (CET)
Received: from mail2.postbox.xyz ([IPv6:::1])
        by localhost (mail2.postbox.xyz [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id T90wm8VbV1z8 for <linux-xfs@vger.kernel.org>;
        Thu, 10 Nov 2016 15:15:48 +0100 (CET)
Received: from mail2.postbox.xyz (localhost [IPv6:::1])
        by mail2.postbox.xyz (Postfix) with ESMTP
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2016 15:15:48 +0100 (CET)
Message-ID: <44d2cb2765781d64e9549b371a2f9686.squirrel@mail2.postbox.xyz>
Date: Thu, 10 Nov 2016 15:15:48 +0100
Subject: sb_agblocks
From: "Chris" <chris2014@postbox.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

All,

howto display size and number of Allocation Groups? I think 1 varialbe is
sb_agblocks.

- Chris

