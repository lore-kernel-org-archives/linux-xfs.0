Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E46C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 19:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC312225D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 19:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgJTTyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 15:54:17 -0400
Received: from mail.qboosh.pl ([217.73.31.61]:55642 "EHLO mail.qboosh.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbgJTTyR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Oct 2020 15:54:17 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2020 15:54:16 EDT
Received: by mail.qboosh.pl (Postfix, from userid 1000)
        id 866671A26DAA; Tue, 20 Oct 2020 21:46:16 +0200 (CEST)
Date:   Tue, 20 Oct 2020 21:46:16 +0200
From:   Jakub Bogusz <qboosh@pld-linux.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Polish translation update for xfsprogs 5.8.0
Message-ID: <20201020194616.GA16307@mail>
References: <20200905162726.GA32628@stranger.qboosh.pl> <d00997e1-c609-4692-8959-c8887a944a67@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d00997e1-c609-4692-8959-c8887a944a67@sandeen.net>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 20, 2020 at 10:53:31AM -0500, Eric Sandeen wrote:
> On 9/5/20 11:27 AM, Jakub Bogusz wrote:
> > Hello,
> > 
> > I prepared an update of Polish translation of xfsprogs 5.8.0.
> > Because of size (whole file is ~551kB, diff is ~837kB),
> > I'm sending just diff header to the list and whole file is available
> > to download at:
> > http://qboosh.pl/pl.po/xfsprogs-5.8.0.pl.po
> > (sha256: 2f0946989b9ba885aa3d3d2b28c5568ce0463a5888b06cfa3f750dc925ceef01)
> > 
> > Whole diff is available at:
> > http://qboosh.pl/pl.po/xfsprogs-5.8.0-pl.po-update.patch
> > (sha256: 355a68fcb9cd7b02b762becabdb100b9498ec8a0147efd5976dc9e743190b050)
> > 
> > Please update.
> 
> Jakub - thank you for this!
> 
> I apologize for somehow missing it.  I can do my best to pull it in for upcoming 5.10,
> or would you like to rebase it?
> 
> One thing to note is that as of 5.9.0, xfs messages from libxfs/* should have been
> added to the message catalog.

I updated translations for 5.9.0 (which seems to match current git master, if
I see correctly).

New pl.po file:
http://qboosh.pl/pl.po/xfsprogs-5.9.0.pl.po
(sha256: d4080708d2a8367cd92fdbbd281d1f5c4978aaa46bb1db1b6234e1025c1ca9b7)

Whole diff is available at:
http://qboosh.pl/pl.po/xfsprogs-5.9.0-pl.po-update.patch
(sha256: b2e9769b31cf073f9c4343acc48351d70c418d0c9d09473e47779ce3a372cfca)


New diff header:

Polish translation update for xfsprogs 5.9.0.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

---
 pl.po |16427 ++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 9033 insertions(+), 7394 deletions(-)

[...]


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/
