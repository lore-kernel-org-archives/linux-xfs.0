Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 896978001
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 18:34:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70BD630408D
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 16:34:11 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id i1i9GrSn4XQrJOQe (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 16:34:09 -0800 (PST)
Date: Tue, 18 Feb 2014 19:33:51 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140219003351.GE7339@thunk.org>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140218010138.GE13997@dastard> <20140218083324.GB28666@dastard>
	<alpine.LFD.2.00.1402181006250.2216@localhost.localdomain>
	<20140218094142.GC28666@dastard>
	<alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
	<20140218142305.GN26580@thunk.org>
	<alpine.LFD.2.00.1402181536110.2216@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402181536110.2216@localhost.localdomain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBGZWIgMTgsIDIwMTQgYXQgMDM6NDI6MTBQTSArMDEwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IAo+IFRvIGJlIGhvbmVzdCAiYmxvY2tfbWFwIiBncm91cCBuYW1lIGRvZXMgbm90
IG1lYW4gYW55dGhpbmcgdG8gbWUuCgpXZWxsLCB0cmFkaXRpb25hbGx5IHRoZSAiYm1hcCIgZnVu
Y3Rpb24gaXMgd2hhdCBpcyB1c2VkIHRvIG1hcCBmcm9tIGFuCmlub2RlIGFuZCBhIGxvZ2NhbCBi
bG9jayBhbmQgYSBwaHlzaWNhbCBibG9jay4gIEkgdGhvdWdodCBibG9ja19tYXAKd2FzIG1vcmUg
b2J2aW91cywgYnV0IG1heWJlIHRoaXMgaXMgYSBjYXNlIHdoZXJlICJibWFwIiB3b3VsZCBiZSBt
b3JlCnVuZGVyc3RhbmRhYmxlPyAgSSBkdW5uby4KCgkJCQkJCS0gVGVkCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
