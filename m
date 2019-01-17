Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfAQTMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 14:12:07 -0500
Date: Thu, 17 Jan 2019 11:11:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/22] xfs: hoist extent size helpers to libxfs
Message-ID: <20190117191153.GF4424@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630914753.18437.17751711685826124435.stgit@magnolia>
 <20190117141825.GA16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117141825.GA16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:18:25AM -0800, Christoph Hellwig wrote:
> Can we move thse to xfs_bmap.c, which includes a few users of these
> little helpers?

Ok.

--D
