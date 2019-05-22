Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40768 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfEVRby (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 13:31:54 -0400
Date: Wed, 22 May 2019 19:31:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190522173132.GA31394@lst.de>
References: <20190520161347.3044-1-hch@lst.de> <20190520161347.3044-15-hch@lst.de> <20190520233233.GF29573@dread.disaster.area> <20190521050943.GA29120@lst.de> <20190521222434.GH29573@dread.disaster.area> <20190522051214.GA19467@lst.de> <20190522061919.GJ29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522061919.GJ29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Does this look fine to you?

http://git.infradead.org/users/hch/xfs.git/commitdiff/8d9600456c6674453dddd5bf36512658c39d7207
