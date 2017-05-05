Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54162 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbdEEJ4S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 05:56:18 -0400
Date: Fri, 5 May 2017 11:56:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Message-ID: <20170505095617.GA6762@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-3-hch@lst.de> <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com> <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493977343.30052.23.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

On Fri, May 05, 2017 at 12:42:23PM +0300, Andy Shevchenko wrote:
> Christoph, I can wait a bit and re-do my patch if we settle down data
> types and function name space.

We should probably just work on a common branch.
