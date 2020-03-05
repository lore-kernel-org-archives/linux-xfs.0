Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD2AC3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 21:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D46D2072A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 21:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEVm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:42:28 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43328 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgCEVm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 16:42:28 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9F4AF7EA4CC;
        Fri,  6 Mar 2020 08:42:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9yG8-0004XK-5p; Fri, 06 Mar 2020 08:42:24 +1100
Date:   Fri, 6 Mar 2020 08:42:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfs: clean up log tickets and record writes
Message-ID: <20200305214224.GK10776@dread.disaster.area>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200305160522.GA4825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305160522.GA4825@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8 a=33O42-wmJ5hJ3almtwAA:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:05:22AM -0800, Christoph Hellwig wrote:
> FYI, I'd prefer to just see the series without patches 6, 7 and 9 for
> now.  They aren't really related to the rest, and I think this series:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-kill-XLOG_STATE_IOERROR

URL not found.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
