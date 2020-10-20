Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80270C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 15:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DB522251
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 15:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436950AbgJTPxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 11:53:32 -0400
Received: from sandeen.net ([63.231.237.45]:44188 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436948AbgJTPxc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Oct 2020 11:53:32 -0400
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2133BF8AE5;
        Tue, 20 Oct 2020 10:53:31 -0500 (CDT)
To:     Jakub Bogusz <qboosh@pld-linux.org>, linux-xfs@vger.kernel.org
References: <20200905162726.GA32628@stranger.qboosh.pl>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] Polish translation update for xfsprogs 5.8.0
Message-ID: <d00997e1-c609-4692-8959-c8887a944a67@sandeen.net>
Date:   Tue, 20 Oct 2020 10:53:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200905162726.GA32628@stranger.qboosh.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/5/20 11:27 AM, Jakub Bogusz wrote:
> Hello,
> 
> I prepared an update of Polish translation of xfsprogs 5.8.0.
> Because of size (whole file is ~551kB, diff is ~837kB),
> I'm sending just diff header to the list and whole file is available
> to download at:
> http://qboosh.pl/pl.po/xfsprogs-5.8.0.pl.po
> (sha256: 2f0946989b9ba885aa3d3d2b28c5568ce0463a5888b06cfa3f750dc925ceef01)
> 
> Whole diff is available at:
> http://qboosh.pl/pl.po/xfsprogs-5.8.0-pl.po-update.patch
> (sha256: 355a68fcb9cd7b02b762becabdb100b9498ec8a0147efd5976dc9e743190b050)
> 
> Please update.

Jakub - thank you for this!

I apologize for somehow missing it.  I can do my best to pull it in for upcoming 5.10,
or would you like to rebase it?

One thing to note is that as of 5.9.0, xfs messages from libxfs/* should have been
added to the message catalog.

Thanks,
-Eric

> 
> Diff header is:
> 
> Polish translation update for xfsprogs 5.8.0.
> 
> Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>
> 
> ---
>  po/pl.po | 17829 +++++++++++++++++++++++++++++++++++-------------------------------
>   1 file changed, 9711 insertions(+), 8118 deletions(-)
> 
> --- xfsprogs-5.8.0/po/pl.po.orig        2020-08-27 02:45:03.000000000 +0200
> +++ xfsprogs-5.8.0/po/pl.po     2020-09-05 18:08:10.009486802 +0200
> [...]
> 
> 
> Regards,
> 
