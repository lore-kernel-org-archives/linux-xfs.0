Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33852 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeEVGrH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 02:47:07 -0400
Date: Tue, 22 May 2018 14:47:02 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 3/5] generic: add test for dedupe on an active swapfile
Message-ID: <20180522064702.GR29080@desktop.hz.ali.com>
References: <cover.1526503000.git.osandov@fb.com>
 <a0b71ac1816cc6dd80f3ace9e406a72137623db2.1526503000.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0b71ac1816cc6dd80f3ace9e406a72137623db2.1526503000.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

On Wed, May 16, 2018 at 01:38:47PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Similar to generic/356 that makes sure we can't reflink an active
                                                  ^^^^^^^ dedupe
I'll fix it on commit.

Thanks,
Eryu
