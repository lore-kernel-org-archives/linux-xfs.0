Return-Path: <SRS0=DzrB=EM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF31C2D0A3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 08:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D8721707
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 08:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgKFIja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 03:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFIj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Nov 2020 03:39:29 -0500
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Nov 2020 00:39:29 PST
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEBFC0613CF
        for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2020 00:39:29 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id A768617D3E7;
        Fri,  6 Nov 2020 09:32:09 +0100 (CET)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-xfs@vger.kernel.org
Cc:     liang bai <darkagainst@gmail.com>
Subject: Re: About material on old xfs wiki
Date:   Fri, 06 Nov 2020 09:32:08 +0100
Message-ID: <2134940.iZASKD2KPV@merkaba>
In-Reply-To: <CA+Kr39MGk=mj0Mx7idzUvkEOxw5qzwfqzWuxN0mgzTGSHLsK5Q@mail.gmail.com>
References: <CA+Kr39MGk=mj0Mx7idzUvkEOxw5qzwfqzWuxN0mgzTGSHLsK5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

liang bai - 06.11.20, 09:14:05 CET:
> I am doing some research about how SSD can better cooperate with XFS.
> So I need to know much about the design of the XFS.
> I find some material in new xfs wiki, but I would like to know more
> about internal design and details in old xfs wiki. It's a pity that
> the old one
> can not work now. I'd like to know if the web will recover and if
> there is a way to get the material.

Internet Archive Wayback machine to the rescue:

Try this:

https://web.archive.org/web/20200518215919/https://xfs.org/index.php/
Main_Page

Thanks,
-- 
Martin


