Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53261 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbcJZKZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:25:26 -0400
Date: Wed, 26 Oct 2016 03:25:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/39] xfs: introduce the CoW fork
Message-ID: <20161026102524.GF29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743666109.11035.5850104676966406279.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743666109.11035.5850104676966406279.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:04:21PM -0700, Darrick J. Wong wrote:
> Introduce a new in-core fork for storing copy-on-write delalloc
> reservations and allocated extents that are in the process of being
> written out.
> 
> [Clean up the CoW fork, should there ever be one.]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

What's up with all these odd commit message and tiny not really
standalone patches?
