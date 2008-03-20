Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 17:13:09 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K0CxkZ009693
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 17:13:01 -0700
From: Niv Sardi <xaiki@debian.org>
Subject: Re: xfsdump debian package, wrong version number
References: <87iqzi3b8q.fsf@petole.dyndns.org>
Date: Thu, 20 Mar 2008 11:13:16 +1100
In-Reply-To: <87iqzi3b8q.fsf@petole.dyndns.org> (Nicolas KOWALSKI's message of
	"Wed, 19 Mar 2008 17:54:45 +0100")
Message-ID: <nccod9antgj.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nicolas KOWALSKI <niko@petole.dyndns.org>
Cc: xfs@oss.sgi.com

Debian packaging is not made in upstream repository.

quick fix: hand edit debian/changelog
or get the dsc from http://packages.debian.org/sid/xfsdump and rebuild
for your favourite flavour.

Cheers,
-- 
Niv Sardi
