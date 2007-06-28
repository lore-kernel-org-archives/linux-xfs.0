Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 11:58:02 -0700 (PDT)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SIvrtL004404
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 11:57:54 -0700
Message-ID: <468404A0.503@garzik.org>
Date: Thu, 28 Jun 2007 14:57:36 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
References: <20070510223950.GD86004887@sgi.com>	<20070511110301.GB28425@in.ibm.com>	<20070512080157.GF85884050@sgi.com>	<20070612061652.GA6320@amitarora.in.ibm.com>	<20070613235217.GS86004887@sgi.com>	<20070614091458.GH5181@schatzie.adilger.int>	<20070614120413.GD86004887@sgi.com>	<20070614193347.GN5181@schatzie.adilger.int>	<20070625132810.GA1951@amitarora.in.ibm.com>	<20070628025543.9467216f.akpm@linux-foundation.org>	<20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org>
In-Reply-To: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

Andrew Morton wrote:
> b) We do what we normally don't do and reserve the syscall slots in mainline.

If everyone agrees it's going to happen... why not?

	Jeff
