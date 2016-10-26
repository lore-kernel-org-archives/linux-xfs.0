Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37533 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbcJZKsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:48:51 -0400
Date: Wed, 26 Oct 2016 03:48:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/39] xfs_repair: fix get_agino_buf to avoid corrupting
 inodes
Message-ID: <20161026104849.GA8254@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743678067.11035.13255641695282180016.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743678067.11035.13255641695282180016.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
