Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43545 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdBAOsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 09:48:02 -0500
Date: Wed, 1 Feb 2017 06:48:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/7] xfs: fix toctou race when locking an inode to
 access the data map
Message-ID: <20170201144801.GA27071@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
 <20170201023454.GK9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170201023454.GK9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
