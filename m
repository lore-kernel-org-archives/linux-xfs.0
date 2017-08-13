Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50210 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbdHMJI5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Aug 2017 05:08:57 -0400
Date: Sun, 13 Aug 2017 11:08:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing
        and dirtying helpers
Message-ID: <20170813090855.GA32112@lst.de>
References: <20170811151805.22896-1-hch@lst.de> <f4d52f4d8b1cb6dfb91acaa8612d4bba@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4d52f4d8b1cb6dfb91acaa8612d4bba@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, stockhausen@collogia.de, it+linux-nfs@molgen.mpg.de

Hi Paul,

I'm overdue doing another XFS stable backport batch, and I will
include this patch.
