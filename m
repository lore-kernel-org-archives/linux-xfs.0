Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 17:18:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8Q0IJaG021198
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 17:18:20 -0700
Received: from smtp101.sbc.mail.mud.yahoo.com (smtp101.sbc.mail.mud.yahoo.com [68.142.198.200])
	by cuda.sgi.com (Spam Firewall) with SMTP id 3488045F730
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 17:17:39 -0700 (PDT)
Date: Mon, 25 Sep 2006 17:17:37 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: LVM and XFS cannot set blocksize on block device
Message-ID: <20060926001737.GA10224@tuatara.stupidest.org>
References: <45185424.2030707@tulane.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45185424.2030707@tulane.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <rsalmon@tulane.edu>
Cc: xfs@oss.sgi.com

On Mon, Sep 25, 2006 at 05:11:48PM -0500, Rene Salmon wrote:

> Warning: the data subvolume sector size 512 is less than the sector size
> reported by the device (4096).

does "-s size=4096" help?
