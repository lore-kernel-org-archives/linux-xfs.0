Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8756C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 05:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A362B61242
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 05:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhHWFFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 01:05:19 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:55281 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWFFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 01:05:19 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2021 01:05:18 EDT
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id E43C661C4D;
        Mon, 23 Aug 2021 14:57:03 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 2W1j5WUOCGRa; Mon, 23 Aug 2021 14:57:03 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 87B9761C39;
        Mon, 23 Aug 2021 14:57:02 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 0CB94680468; Mon, 23 Aug 2021 14:57:02 +1000 (AEST)
Date:   Mon, 23 Aug 2021 14:57:01 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20210823045701.GA2186939@onthe.net.au>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180125055144.qztiqeakw4u3pvqf@destitution>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Thu, Jan 25, 2018 at 04:51:44PM +1100, Dave Chinner wrote:
> The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> snapshot support I'm working on has been uploaded and can be found
> here:
>
> https://www.youtube.com/watch?v=wG8FUvSGROw

Just out of curiosity... is anything still happening in this area, and if 
so, is there anywhere we can look to get a feel for the current state of 
affairs?

Cheers,

Chris
