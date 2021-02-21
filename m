Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1127DC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0C1564E04
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhBUECO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 23:02:14 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41577 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229903AbhBUECN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 23:02:13 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3FBF0102ACE4;
        Sun, 21 Feb 2021 15:01:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDfw1-00EYhE-Ig; Sun, 21 Feb 2021 15:01:29 +1100
Date:   Sun, 21 Feb 2021 15:01:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Dimitri John Ledkov <xnox@ubuntu.com>
Subject: Re: [PATCH 1/4] debian: Drop trying to create upstream distribution
Message-ID: <20210221040129.GK4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-2-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220121610.3982-2-bastiangermann@fishpost.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=ZlwnE7edCjYEy9UHtmYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 20, 2021 at 01:16:06PM +0100, Bastian Germann wrote:
> This is a change introduced in 4.3.0+nmu1ubuntu1.

Why? When the change was made is not important, explaining why the
change needs to be made is what should be in the commit message.
i.e. Tell us why this isn't needed any more...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
