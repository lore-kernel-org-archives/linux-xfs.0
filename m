Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36450 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbeI0DpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 23:45:24 -0400
Date: Wed, 26 Sep 2018 14:30:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/24] docs: carry a copy of the CC-by-SA 3.0 license
Message-ID: <20180926213028.GA22763@infradead.org>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
 <153799046767.31202.13234065186281153272.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153799046767.31202.13234065186281153272.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 12:34:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add the CC-BY-SA 3.0 license so that the XFS Data Structures &
> Algorithms book can reference it with spdx headers.

NAK.  We should not add random new licenses to the kernel tree.
