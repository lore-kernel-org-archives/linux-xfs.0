Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59468 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbdJAIA2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Oct 2017 04:00:28 -0400
Date: Sun, 1 Oct 2017 10:00:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] generic/447: not a quick test
Message-ID: <20171001080026.GE11554@lst.de>
References: <1506616841-24121-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506616841-24121-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Sep 28, 2017 at 07:40:41PM +0300, Amir Goldstein wrote:
> It hogged my cpu for a good 300s.
> Test was inheritted from generic/176, which is not quick.

True.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
