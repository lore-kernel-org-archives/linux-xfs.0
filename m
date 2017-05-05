Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39212 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbdEEKIC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 06:08:02 -0400
Message-ID: <1493978788.30052.29.camel@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 05 May 2017 13:06:28 +0300
In-Reply-To: <20170505095617.GA6762@lst.de>
References: <20170505075725.19597-1-hch@lst.de>
         <20170505075725.19597-3-hch@lst.de>
         <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
         <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com>
         <20170505095617.GA6762@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

On Fri, 2017-05-05 at 11:56 +0200, Christoph Hellwig wrote:
> On Fri, May 05, 2017 at 12:42:23PM +0300, Andy Shevchenko wrote:
> > Christoph, I can wait a bit and re-do my patch if we settle down
> > data
> > types and function name space.
> 
> We should probably just work on a common branch.

Works for me. Are you volunteering to provide a such?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
