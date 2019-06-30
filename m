Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF3PkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 11:40:05 -0400
Date: Sun, 30 Jun 2019 08:39:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630153955.GF1404256@magnolia>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> Hi,
> 
> I have been running with Dave's series for faster directory inserts since
> forever without any issues, and the last revision [1] still applies cleanly
> to current5.2-rc (not sure about xfs-next though).
> Any chance this can be included in 5.3? IMHO it would be a shame if this
> fell through the cracks again.
> 
> Thanks,
> Holger
> 
> [1] https://patchwork.kernel.org/project/xfs/list/?series=34713

Christoph reviewed most of the series, but it looked like he and Dave
went back and forth a bit on the second to last patch and Dave never
sent a v2 series or a request to just merge it as is, so I didn't take
any action.  Hey Dave, are you still working on a resubmission for this
series?

--D
