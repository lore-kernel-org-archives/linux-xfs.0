Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:08:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P58qc6015123
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:08:53 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA09232; Fri, 25 Jul 2008 15:09:59 +1000
Message-ID: <48896038.4060207@sgi.com>
Date: Fri, 25 Jul 2008 15:10:16 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] kill INDUCE_IO_ERROR
References: <20080523062323.GA32637@lst.de> <nccprp2twjw.fsf@itchy.melbourne.sgi.com> <20080725043259.GB21392@lst.de>
In-Reply-To: <20080725043259.GB21392@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jul 25, 2008 at 02:30:43PM +1000, Niv Sardi wrote:
>> looks good, checking it in
> 
> Donald NACKed this one..
> 

Yep, but I changed my mind on it a while ago, the blocklayer
error injection looks like a more useful framework for testing
with release builds.

Niv and I chatted about it and its fine by me.

Don
