Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:35727 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965015AbeFOCdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 22:33:07 -0400
Date: Fri, 15 Jun 2018 12:33:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mkfs: remove notion of config "type"
Message-ID: <20180615023304.GP10363@dastard>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8c2a5a07-5d47-48a1-1593-e93eb0fb883a@sandeen.net>
 <20180614164121.GC6825@magnolia>
 <20180614234239.GO10363@dastard>
 <CAB=NE6V7JmsPpkCB1zp0CuY5YTJvMonG7UJPjScKYVJZLWb3xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6V7JmsPpkCB1zp0CuY5YTJvMonG7UJPjScKYVJZLWb3xg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 14, 2018 at 07:10:09PM -0700, Luis R. Rodriguez wrote:
> Silly mobile gmail interface not letting me bottom-post... What if we treat
> no version being present as version 0?

We haven't released anything yet so we should put it in there from
the start rather than having to work around the lack of a version
field later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
