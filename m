Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33452 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdLFN77 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 08:59:59 -0500
Subject: Re: [xfsprogs PATCH v2 1/3] xfs_io: fix compiler warnings in getfsmap
 code
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-2-ross.zwisler@linux.intel.com>
 <20171206002743.GC5858@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <863e00bb-107a-7469-b573-0545ede8e2bd@sandeen.net>
Date: Wed, 6 Dec 2017 07:59:58 -0600
MIME-Version: 1.0
In-Reply-To: <20171206002743.GC5858@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On 12/5/17 6:27 PM, Dave Chinner wrote:

> FYI, I posted a fix for this weeks ago. I think Eric has already
> picked it up, but it hasn't been pushed out into the for-next branch
> yet.

Yes, sorry for the delay.  Will be pushed out soon.
 
> Cheers,
> 
> Dave.
> 
