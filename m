Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 09:48:45 -0700 (PDT)
Received: from rrzmta2.rz.uni-regensburg.de (rrzmta2.rz.uni-regensburg.de [194.94.155.53])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2NGmb6p024868
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 09:48:38 -0700
Date: Fri, 23 Mar 2007 17:25:22 +0100
From: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Subject: Re: xfs_repair on Debian testing 64bits
Message-ID: <20070323162522.GA27240@pc51072.physik.uni-regensburg.de>
Reply-To: christian.guggenberger@physik.uni-regensburg.de
References: <1174655443.5441.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174655443.5441.37.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Patrick =?iso-8859-1?Q?No=EBl?= <patrick.noel@argus-presse.fr>
Cc: xfs@oss.sgi.com

> i try to force 8 thread with -o thread=8
> 
> and i have this message :
> 
>  xfs_repair -o thread=8 /dev/sdb1
>  - creating 8 worker thread(s)
> 
> 
> but with ps xa  | grep repair i see only one thread.
>

IMHO, you'll need 'ps xaH' 

cheers.
 - Christian
