Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdLUNjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 08:39:54 -0500
Date: Thu, 21 Dec 2017 05:39:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/4] xfs: clean up cow mappings during fs data freeze
Message-ID: <20171221133953.GE10079@infradead.org>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <20171219210946.GH12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219210946.GH12613@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

This needs to be a separate thread including -fsdevel.
