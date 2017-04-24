Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31892 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969574AbdDXV1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2017 17:27:21 -0400
Date: Mon, 24 Apr 2017 14:27:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs: introduce xfs_bmapi_remap
Message-ID: <20170424212713.GQ23371@birch.djwong.org>
References: <20170412103013.9355-1-hch@lst.de>
 <20170412103013.9355-5-hch@lst.de>
 <20170412192827.GQ8502@birch.djwong.org>
 <20170419180757.GA26319@lst.de>
 <20170419183250.GI5193@birch.djwong.org>
 <20170424144714.GA29860@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170424144714.GA29860@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2017 at 04:47:14PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 19, 2017 at 11:32:50AM -0700, Darrick J. Wong wrote:
> > Seems fine in testing here.  I was planning to push it for 4.12.
> 
> Ok.  Just been wondering because the for-next branch hasn't seen
> any updated for a long time.

Yeah, I was going to do that on Friday but then uncovered that bug with
fmh_entries in getfsmap and decided to let testing run through the
weekend.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
