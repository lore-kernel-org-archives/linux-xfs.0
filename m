Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 08:22:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6MFLiD0018529
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 08:21:45 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F5C419194AB
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 08:22:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AT6Gn94fApcv6O20 for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 08:22:54 -0700 (PDT)
Message-ID: <4885FB40.5000807@sandeen.net>
Date: Tue, 22 Jul 2008 10:22:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_btree_check_lblock
References: <4880AEF8.2080906@cape-horn-eng.com> <48815AA6.3080102@sgi.com> <4884B419.6080603@thebarn.com> <488552EC.8060803@sgi.com> <4885BB2E.3010508@cape-horn-eng.com> <4885C425.9020309@sgi.com>
In-Reply-To: <4885C425.9020309@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com, Bill O'Donnell <billodo@sgi.com>

Mark Goodwin wrote:
> 
> Richard Ems wrote:


>> When can we *expect* to have these patches backported? In one month?
>> Three months? More?
> 
> For SLES, within a week. For OpenSuSE presumeably the SLES folks will
> follow-up with OpenSuSE, but I can't predict when. For Fedora, Eric
> Sandeen.  For RHEL (on anything except SGI storage platforms), nobody
> since XFS is not supported directly by Redhat.

Nor even shipped with RHEL.

But hopefully the CentOS guys will pick it up, I'll give them a heads up
when the list of fixes appears.

Thanks,
-Eric
