Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61655 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbfBEWHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 17:07:09 -0500
Date: Wed, 6 Feb 2019 09:06:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190205220655.GF14116@dastard>
References: <20190204165427.23607-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
> Kernel stable team,
> 
> here is a v2 respin of my XFS stable patches for v4.19.y. The only
> change in this series is adding the upstream commit to the commit log,
> and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> were spotted or raised with this series.
> 
> Reviews, questions, or rants are greatly appreciated.

Test results?

The set of changes look fine themselves, but as always, the proof is
in the testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
