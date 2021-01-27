Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08928C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 22:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB67864D9F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 22:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhA0WSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 17:18:49 -0500
Received: from relayout04-q02.e.movistar.es ([86.109.101.172]:26791 "EHLO
        relayout04-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236397AbhA0WSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 17:18:47 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2021 17:18:46 EST
Received: from relayout04-redir.e.movistar.es (unknown [86.109.101.204])
        by relayout04-out.e.movistar.es (Postfix) with ESMTP id 4DQyRy2mZ0z20kG
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:09:02 +0100 (CET)
Received: from Telcontar.valinor (39.red-83-53-59.dynamicip.rima-tde.net [83.53.59.39])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout04.e.movistar.es (Postfix) with ESMTPSA id 4DQyRt0XKjz11kJ
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:08:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 96E173225EB
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:08:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id brviHXOIEDHE for <linux-xfs@vger.kernel.org>;
        Wed, 27 Jan 2021 23:08:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 7A3383225EA
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:08:57 +0100 (CET)
Date:   Wed, 27 Jan 2021 23:08:50 +0100 (CET)
From:   "Carlos E. R." <robin.listas@telefonica.net>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: test message
In-Reply-To: <20210127033444.GG7698@magnolia>
Message-ID: <19702ced-8be-213f-a32-93354dd492c@telefonica.net>
References: <20210127033444.GG7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-TnetOut-Country: IP: 83.53.59.39 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout04
X-TnetOut-MsgID: 4DQyRt0XKjz11kJ.A1E72
X-TnetOut-SpamCheck: no es spam (whitelisted), clean
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1612390140.81335@lPTWWGOX3jgOUN5aDMSdpw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Tuesday, 2021-01-26 at 19:34 -0800, Darrick J. Wong wrote:

> Hm.  I'm missing a substantial amount of list traffic, and I can't tell
> if vger is still slow or if it's mail.kernel.org forwarding that's
> busted.
>
> Hmm, a message I just sent to my oracle address works fine, so I guess
> it's vger that's broken?  Maybe?  I guess we'll see when this shows
> up; the vger queue doesn't seem to have anything for xfs right now.
>
> <grumble>

I see your post took an hour and a half to arrive to me.


(2021-01-27T03:34:44+00:00 UTC)    Tue, 26 Jan 2021 19:34:44 -0800  Sent.

(2021-01-27T03:34:45+00:00 UTC)    Wed, 27 Jan 2021 03:34:45 +0000 (UTC)       mail.kernel.org (Postfix) got it

(2021-01-27T03:35:26+00:00 UTC)    Tue, 26 Jan 2021 22:35:26 -0500             vger.kernel.org with ESMTP got it from mail.kernel.org ([198.145.29.99]:34390)

(2021-01-27T05:05:26+00:00 UTC)    Wed, 27 Jan 2021 00:05:26 -0500             vger.kernel.org via listexpand got it from (majordomo@vger.kernel.org)

(2021-01-27T05:06:09+00:00 UTC)    Wed, 27 Jan 2021 06:06:09 +0100 (CET)       relayin02.e.movistar.es (Postfix) with ESMTP got it from vger.kernel.org ([23.128.96.18])


I used this command to normalize timestamps:

cer@Telcontar:~> TZ=UTC date --iso-8601=seconds -d "Wed, 27 Jan 2021 06:06:09 +0100"
2021-01-27T05:06:09+00:00
cer@Telcontar:~>



- -- 
Cheers,
        Carlos E. R.
        (from openSUSE 15.2 x86_64 at Telcontar)

-----BEGIN PGP SIGNATURE-----

iHoEARECADoWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCYBHkchwccm9iaW4ubGlz
dGFzQHRlbGVmb25pY2EubmV0AAoJELUzGBxtjUfVA6AAnRpaN1Np9g4moqR3ulIj
aKTeJd9gAJ9tAE4r0jiAo4+tH/koS/dkwi34ZA==
=Wewu
-----END PGP SIGNATURE-----
