Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdATKFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 05:05:05 -0500
Date: Fri, 20 Jan 2017 02:05:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: fix missing syncfs command
Message-ID: <20170120100504.GD32659@infradead.org>
References: <1484904118-17703-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484904118-17703-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Oops..  Time to add tests that use syncfs :)

Reviewed-by: Christoph Hellwig <hch@lst.de>
