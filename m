Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 May 2007 07:12:59 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l48ECufB017002
	for <xfs@oss.sgi.com>; Tue, 8 May 2007 07:12:56 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 25E8E1E0D5967
	for <xfs@oss.sgi.com>; Tue,  8 May 2007 21:55:59 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1NVf-U3wH6+s for <xfs@oss.sgi.com>;
	Tue,  8 May 2007 21:55:56 +0800 (PHT)
Received: from musang.fs3.ph (smtp01.globe.com.ph [203.177.91.252])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id A97BD1E0D5953
	for <xfs@oss.sgi.com>; Tue,  8 May 2007 21:55:55 +0800 (PHT)
Date: Tue, 8 May 2007 21:55:42 +0800
From: Federico Sevilla III <jijo@fs3.ph>
Subject: Re: Problems with XFS in a power failure
Message-ID: <20070508135542.GF5621@fs3.ph>
References: <20070508091613.GA5852@cepheus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070508091613.GA5852@cepheus>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, May 08, 2007 at 11:16:14AM +0200, Uwe Kleine-König wrote:
> my machine suffered a power failure while doing a apt-get upgrade.

Uh-oh. You hit the (in)famous binary nulls "issue". You may want to read
the FAQ entry: http://oss.sgi.com/projects/xfs/faq.html#nulls.

-- 
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph
