Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 16:47:15 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1D0l7ld010269
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 16:47:11 -0800
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 277775CC743
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 16:47:31 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id mUiOUkD5OBjSHSuC for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 16:47:31 -0800 (PST)
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.2/8.14.2/Debian-3) with ESMTP id m1D0keIc004599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 11:46:40 +1100
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.2/8.14.2/Submit) id m1D0ke8v004598
	for xfs@oss.sgi.com; Wed, 13 Feb 2008 11:46:40 +1100
Date: Wed, 13 Feb 2008 11:46:39 +1100
From: Jason White <jason@jasonjgw.net>
Subject: Re: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
Message-ID: <20080213004639.GA4534@jdc.jasonjgw.net>
References: <20080205052418.GU155259@sgi.com> <20080209120423.GA6699@diesel.geggus.net> <20080211001727.GO155407@sgi.com> <1202711725.4679.7.camel@humanitas.fs3.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202711725.4679.7.camel@humanitas.fs3.ph>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Feb 11, 2008 at 02:35:25PM +0800, Federico Sevilla III wrote:
 
> 2.6.24.2 has been released to address the vmsplice issue. Unfortunately,
> no other changes seem to have been included. Hopefully, the
> xfs_file_readdir patch will make it to 2.6.24.3.

Which platforms are affected? My machines are x86_64, and I've just upgraded
to avoid the vmsplice exploit.

Of course, I could compile a patched kernel but if this platform isn't
affected then I might as well wait for 2.6.24.3.

I know that's a really lazy kind of question.
