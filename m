Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 06:29:00 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48DStfB001716
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 06:28:57 -0700
Date: Tue, 8 May 2007 15:28:53 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problems with XFS in a power failure
Message-ID: <20070508152853.1d387fea@galadriel.home>
In-Reply-To: <20070508091613.GA5852@cepheus>
References: <20070508091613.GA5852@cepheus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>
Cc: xfs@oss.sgi.com

Le Tue, 8 May 2007 11:16:14 +0200 vous écriviez:

> In theory this should not happen with a journaled fs, does it?

That's the opposite. It's the expected behaviour. It's especially
important to garantee proper power when using journaling filesystems. 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
