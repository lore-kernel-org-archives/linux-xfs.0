Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E4097F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 10:36:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98D9BAC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 08:36:53 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id szHA7c2oxD8w81mE (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 08:36:48 -0700 (PDT)
Date: Tue, 15 Apr 2014 11:36:43 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Message-ID: <20140415153643.GB4456@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
	<alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBBcHIgMTUsIDIwMTQgYXQgMDM6MTA6MzhQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IAo+IEknbGwgdXBkYXRlIHRoZSBkZXNjcmlwdGlvbiBhbmQgdGhlIHN1YmplY3Qu
CgpMdWvDocWhLCBGWUksIEknbSB3YWl0aW5nIGZvciB5b3VyIHVwZGF0ZShzKSB0byB0aGVzZSBw
YXRjaGVzIGluCnJlc3BvbnNlIHRvIENocmlzdG9waCdzIGNvbW1lbnRzLgoKSSdkIGxpa2UgdG8g
cHVzaCBhIHNldCBvZiBidWdmaXhlcyB0byBMaW51cywgaG9wZWZ1bGx5IHRoaXMgd2VlayBzbwp0
aGV5IGNhbiBtYWtlIC1yYzIuCgpDaGVlcnMsCgoJCQkJCS0gVGVkCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
