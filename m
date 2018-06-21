Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50452 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbeFUHoH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 03:44:07 -0400
Date: Thu, 21 Jun 2018 09:53:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180621075323.GA4880@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-24-hch@lst.de> <20180619165211.GD2806@bfoster> <20180620075655.GA2668@lst.de> <20180620143252.GE3241@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620143252.GE3241@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 20, 2018 at 10:32:53AM -0400, Brian Foster wrote:
> Sending again without the attachment... Christoph, let me know if it
> didn't hit your mbox at least.

I did get the previous one as well as this one.
