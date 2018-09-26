Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbeI0FcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 01:32:08 -0400
Date: Wed, 26 Sep 2018 16:16:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/24] docs: carry a copy of the CC-by-SA 3.0 license
Message-ID: <20180926231606.GZ20086@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
 <153799046767.31202.13234065186281153272.stgit@magnolia>
 <20180926213028.GA22763@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926213028.GA22763@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 02:30:28PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 26, 2018 at 12:34:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add the CC-BY-SA 3.0 license so that the XFS Data Structures &
> > Algorithms book can reference it with spdx headers.
> 
> NAK.  We should not add random new licenses to the kernel tree.

The Data Structures & Algorithsm book claims to be licensed under
CC-BY-SA 3.0 or later.  Can we stretch that to mergigin it into the
kernel under CC-BY-SA 4.0, which is already conveniently in LICENSES/ ?

--D
