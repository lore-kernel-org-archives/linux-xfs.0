Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45642 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbcKFQgD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Nov 2016 11:36:03 -0500
Date: Sun, 6 Nov 2016 17:36:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
Message-ID: <20161106163601.GA15675@lst.de>
References: <1478276479-10749-1-git-send-email-hch@lst.de> <1478276479-10749-5-git-send-email-hch@lst.de> <2dabe3ec-193b-3ecf-af5c-a5ba976de6eb@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dabe3ec-193b-3ecf-af5c-a5ba976de6eb@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

> Does this include support for more than one concurrent appending write for 
> the same file?

No.
