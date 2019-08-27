Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DABC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A5E2186A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfH0FB0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 01:01:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39140 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbfH0FB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 01:01:26 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9F36012FD2E;
        Tue, 27 Aug 2019 15:01:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2Tbd-0002wa-VS; Tue, 27 Aug 2019 15:01:21 +1000
Date:   Tue, 27 Aug 2019 15:01:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_spaceman: remove typedef usage
Message-ID: <20190827050121.GV1119@dread.disaster.area>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
 <156685442641.2839773.8716818263249998332.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685442641.2839773.8716818263249998332.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:20:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Kill off the struct typedefs inside spaceman.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

more gone!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
