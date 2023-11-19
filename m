Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53868C54FB9
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Nov 2023 22:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjKSW2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Nov 2023 17:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjKSW2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2023 17:28:52 -0500
X-Greylist: delayed 7942 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Nov 2023 14:28:48 PST
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0033F2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Nov 2023 14:28:48 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id CDC688178CD;
        Sun, 19 Nov 2023 23:28:46 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfsprogs-6.5.0 with grub 2.12~rc1-12: unknown filesystem
Date:   Sun, 19 Nov 2023 23:28:46 +0100
Message-ID: <1889442.tdWV9SEqCh@lichtvoll.de>
In-Reply-To: <ZVp47fergtXq8CzX@technoir>
References: <4545292.LvFx2qVVIh@lichtvoll.de> <ZVp47fergtXq8CzX@technoir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Anthony Iliopoulos - 19.11.23, 22:06:53 CET:
> > Is this a known issue? I bet it needs a bug report to the GRUB
> > developers?
> See:
> https://lore.kernel.org/grub-devel/20231026095339.31802-1-ailiop@suse.com/

Thank you, Anthony.

So no bug report needed anymore.

-- 
Martin


