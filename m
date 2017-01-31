Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30629 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdAaHnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 02:43:39 -0500
Date: Mon, 30 Jan 2017 23:41:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: clear _XBF_PAGES from buffers when readahead
 page allocation fails
Message-ID: <20170131074159.GC6442@birch.djwong.org>
References: <20170126035330.GU9134@birch.djwong.org>
 <20170128225517.GE316@dastard>
 <20170130233557.GA6442@birch.djwong.org>
 <20170130234415.GC9134@birch.djwong.org>
 <20170131073147.GA4463@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131073147.GA4463@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jan 30, 2017 at 11:31:47PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 30, 2017 at 03:44:15PM -0800, Darrick J. Wong wrote:
> > Actually -- Christoph, are you planning to send another batch of XFS
> > fixes for 4.9?
> 
> Yes, it is on my todo list for this week.

Ok, thanks!

--D
